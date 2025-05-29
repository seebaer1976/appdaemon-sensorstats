import appdaemon.plugins.hass.hassapi as hass
import pymysql

class SensorChangeMonitor(hass.Hass):

    def initialize(self):
        self.log("SensorChangeMonitor startet...")
        self.run_every(self.check_changes, "now", 3600)  # alle 60 Min.

    def check_changes(self, kwargs):
        conn = pymysql.connect(host="192.168.35.35",
                               user="homeassistant",
                               password="rommel",
                               db="homeassistant",
                               charset='utf8mb4',
                               cursorclass=pymysql.cursors.DictCursor)
        try:
            with conn.cursor() as cursor:
                sql = """
                SELECT entity_id, COUNT(*) as changes
                FROM states
                WHERE last_updated >= NOW() - INTERVAL 1 DAY
                GROUP BY entity_id
                ORDER BY changes DESC
                LIMIT 10;
                """
                cursor.execute(sql)
                result = cursor.fetchall()
                msg = "TOP 10 Sensoren (24h): " + ", ".join(
                    [f"{row['entity_id']} ({row['changes']})" for row in result])
                self.log(msg)
                self.set_state("sensor.top_state_change_sensors", state=msg)
        finally:
            conn.close()