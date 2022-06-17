SELECT  a.ddate adate, a.aprice air, t.tprice train,h.hprice hotel FROM

            (SELECT DISTINCT date(date) ddate, type, SUM(price) aprice FROM  trips
            INNER JOIN orders o
            ON trips.id = o.fk_trip_id AND type='air'
            GROUP BY date(date), type) a,

            (SELECT DISTINCT date(date) ddate, type, SUM(price) tprice FROM  trips
            INNER JOIN orders o
            ON trips.id = o.fk_trip_id AND type='train'
            GROUP BY date(date), type) t,

            (SELECT DISTINCT date(date) ddate, type, SUM(price) hprice FROM trips
            INNER JOIN orders o
            ON trips.id = o.fk_trip_id AND type='hotel'
            GROUP BY date(date), type) h

            WHERE a.ddate=t.ddate AND t.ddate=h.ddate AND  a.ddate IN (
                    SELECT DISTINCT date(date) FROM  trips
                    LEFT JOIN orders o
                    ON trips.id = o.fk_trip_id
                    GROUP BY date(date)
                    HAVING SUM(o.price)>'10000'
            )
            GROUP BY tprice, aprice,hprice, a.ddate, t.ddate,h.ddate
            ORDER BY aprice+tprice+hprice DESC;