(set-logic QF_S)
(set-option :parse-transducers true)

; SAT control for automatic-island-unary-before-witness.smt2.  input = "c",
; output = "c", and expanded = "cc" violate membership in (cccc)*.

(define-funs-rec (
     (extract0 ((source String) (output String)) Bool)
     (extract0_1 ((source String) (output String)) Bool)
     (extract0_drain ((source String) (output String)) Bool)
  )(
    (or
      (and (= source "") (= output ""))
      (and (not (= source ""))
           (= (str.head source) (char.from-int (str.to_code "p")))
           (extract0_drain (str.tail source) output))
      (and (not (= source "")) (not (= output ""))
           (not (= (str.head source)
                   (char.from-int (str.to_code "p"))))
           (= (str.head_code source) (str.head_code output))
           (extract0_1 (str.tail source) (str.tail output))))
    (or
      (and (= source "") (= output ""))
      (and (not (= source ""))
           (extract0 (str.tail source) output)))
    (or
      (and (= source "") (= output ""))
      (and (not (= source ""))
           (extract0_drain (str.tail source) output)))
  )
)

(define-funs-rec (
     (extract1 ((source String) (output String)) Bool)
     (extract1_1 ((source String) (output String)) Bool)
     (extract1_drain ((source String) (output String)) Bool)
  )(
    (or
      (and (= source "") (= output ""))
      (and (not (= source ""))
           (extract1_1 (str.tail source) output)))
    (or
      (and (= source "") (= output ""))
      (and (not (= source ""))
           (= (str.head source) (char.from-int (str.to_code "p")))
           (extract1_drain (str.tail source) output))
      (and (not (= source "")) (not (= output ""))
           (not (= (str.head source)
                   (char.from-int (str.to_code "p"))))
           (= (str.head_code source) (str.head_code output))
           (extract1 (str.tail source) (str.tail output))))
    (or
      (and (= source "") (= output ""))
      (and (not (= source ""))
           (extract1_drain (str.tail source) output)))
  )
)

(declare-fun source () String)
(declare-fun input () String)
(declare-fun output () String)
(declare-fun expanded () String)

(assert (str.in_re source (re.from_automaton "automaton paired_replace {
  init q0;
  q0 -> qa [97,97];
  q0 -> qb [98,98];
  q0 -> qc [99,99];
  qa -> q0 [97,97];
  qb -> q0 [97,97];
  qc -> q0 [99,99];
  accepting q0;
}")))
(assert (extract0 source input))
(assert (extract1 source output))
(assert (str.in_re input
  (re.* (re.union (str.to_re "a") (str.to_re "b") (str.to_re "c")))))
(assert (str.in_re output (re.* (str.to_re "c"))))

(assert (= expanded (str.replace_all input "c" "cc")))
(assert (not (str.in_re expanded
  (re.* (re.++ (str.to_re "c") (str.to_re "c")
                (str.to_re "c") (str.to_re "c"))))))

(check-sat)
