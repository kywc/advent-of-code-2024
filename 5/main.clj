(require '[clojure.data.json :as json])
; (disj set key) to remove - in core
; slurp for io
(def rules
  (json/read-str (slurp "seq1.json")))
(def updates
  (json/read-str (slurp "updates.json")))

(def rulemaps [] ; "lt" --> all pages that should come after it
  (let [rm {}]
    (for [rule in rules]
      (if-let [lt (:lt rule)
               gt (:gt rule)
               prev (get rm (str lt))]
        (assoc rm (str lt) (conj prev gt))
        (assoc rm (str lt) #{ gt })))
    rm)
rm)

(def main []
  (defn inner-reducr [s item]
    (conj (disj s item) #{ (get rulemaps (str item)) }))
  (defn outer-map [update]
    (if (== (count (reduce reducr #{} update)) 0)
       

