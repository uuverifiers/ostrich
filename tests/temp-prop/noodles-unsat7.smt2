(set-info :smt-lib-version 2.6)
(set-logic QF_S)
(set-info :source |
Generated by: Oliver Markgraf
Generated on: 2024-03-18
Application: Word equations + Regular Constraints
Target solver: OSTRICH
|)
(set-info :license "https://creativecommons.org/licenses/by/4.0/")
(set-info :category "industrial")
(set-info :status unknown)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= (str.++ z y x) (str.++ x x z)))
(assert (str.in_re x (re.++(str.to_re "2") re.all)))
(assert (str.in_re y (re.++(str.to_re "1") re.all)))
(assert (str.in_re z (str.to_re "2")))

(check-sat)
(exit)
