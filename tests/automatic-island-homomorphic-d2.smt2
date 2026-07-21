(set-logic QF_S)
(set-option :parse-transducers true)

; The automatic input relation is carried through two paired replace_all
; layers. Each individual replacement graph is non-automatic.

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

(declare-fun source_in () String)
(declare-fun source_bad () String)
(declare-fun left_0 () String)
(declare-fun right_0 () String)
(declare-fun left_1 () String)
(declare-fun right_1 () String)
(declare-fun left_2 () String)
(declare-fun right_2 () String)

(assert (str.in_re source_in (re.from_automaton "automaton input_relation {
  init q0;
  q0 -> qa [97,97];
  q0 -> qc [99,99];
  qa -> q0 [98,98];
  qc -> q0 [100,100];
  accepting q0;
}")))
(assert (extract0 source_in left_0))
(assert (extract1 source_in right_0))
(assert (str.in_re left_0 (re.* (re.union (str.to_re "a") (str.to_re "c")))))
(assert (str.in_re right_0 (re.* (re.union (str.to_re "b") (str.to_re "d")))))
(assert (str.in_re left_1 (re.* (re.union (str.to_re "a") (str.to_re "c")))))
(assert (str.in_re right_1 (re.* (re.union (str.to_re "b") (str.to_re "d")))))
(assert (str.in_re left_2 (re.* (re.union (str.to_re "a") (str.to_re "c")))))
(assert (str.in_re right_2 (re.* (re.union (str.to_re "b") (str.to_re "d")))))

(assert (= left_1 (str.replace_all left_0 "a" "aa")))
(assert (= right_1 (str.replace_all right_0 "b" "bb")))
(assert (= left_2 (str.replace_all left_1 "a" "aa")))
(assert (= right_2 (str.replace_all right_1 "b" "bb")))

(assert (str.in_re source_bad (re.from_automaton "automaton bad_relation {
  init q0;
  q0 -> qa [97,97];
  q0 -> qc [99,99];
  qa -> q0 [98,98];
  qa -> qbad [100,100];
  qc -> qbad [98,98];
  qc -> q0 [100,100];
  qbad -> qtail [97,97];
  qbad -> qtail [99,99];
  qtail -> qbad [98,98];
  qtail -> qbad [100,100];
  accepting qbad;
}")))
(assert (extract0 source_bad left_2))
(assert (extract1 source_bad right_2))

(check-sat)
