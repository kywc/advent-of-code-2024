(ns advent-3.core
  (:require [clojure.java.io :as io]))

(def regex
  #"mul\((\d+),(\d+)\)")

(defn compute [str]
  (if-let [matches (re-seq regex str)]
    (->> matches (map next)
                 (map (partial map Integer/parseInt))
                 (map (partial apply *))
                 (apply +))
    nil))

(defn -main []
  ((comp println compute slurp io/resource) "input"))
