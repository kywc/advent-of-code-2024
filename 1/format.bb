#!/usr/bin/env bb
(require '[clojure.java.io :as io])
(require '[clojure.string :as str])

(def parse
  (let [in (slurp (io/file "input"))]
    (->> in
      str/split-lines
      (map (fn [x] (str/split x #"   ")))
      interleave
      (split-at (fn [x] (/ (count x 2)))))))

(->> parse
  (map (partial str/join ","))
  (str/join "\n")
  print)
