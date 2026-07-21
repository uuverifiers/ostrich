(set-logic QF_S)
(set-info :status sat)
(set-option :parse-transducers true)

; The source relation is (a,b)*. Its image under a -> aa and b -> a is
; not synchronized, but a concrete source witness still constructs a model.
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
(declare-fun left () String)
(declare-fun right () String)
(declare-fun left_out () String)
(declare-fun right_out () String)

(assert (str.in_re source (re.from_automaton "automaton paired_ab {
  init q0;
  q0 -> q1 [97,97];
  q1 -> q0 [98,98];
  accepting q0;
}")))
(assert (extract0 source left))
(assert (extract1 source right))
(assert (str.in_re left (re.* (str.to_re "a"))))
(assert (str.in_re right (re.* (str.to_re "b"))))

(assert (= left_out (str.replace_all left "a" "aa")))
(assert (= right_out (str.replace_all right "b" "a")))
(assert (distinct left_out right_out))

(check-sat)
