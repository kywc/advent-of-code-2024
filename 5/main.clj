(require '[clojure.data.json :as json])
; (disj set key) to remove - in core
; slurp for io
(def rules
  (json/read-str (slurp "seq1.json")))
(def rulemaps []
  (let [rm #{}]
    (for [rule in rules]
      (if-let [lt (:lt rule)
               gt (:gt rule)
               prev (get rm (str lt))]
        (assoc rm (str lt) (conj prev gt))
        (assoc rm (str lt) #{ gt })))
    rm)
rm)
