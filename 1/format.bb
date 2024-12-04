#!/usr/bin/env bb
(require '[clojure.java.io :as io])
(require '[clojure.string :as str])

(def in2
  (let [in1 (slurp (io/file "input"))]
    (->> in1
      (str/split-lines)
      (map (fn [x] (str/split x #"   ")))
      (apply interleave))))

(def in3 
  (split-at (/ (count in2) 2) in2))

(def in4 (->> in3
  (map (partial str/join ","))
  (str/join #"\n"))) 

(with-open [out (io/writer "output" :append true)]
  (.write out in4))
