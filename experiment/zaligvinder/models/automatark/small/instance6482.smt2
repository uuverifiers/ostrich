(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\d|([a-f]|[A-F])){2}:){5}(\d|([a-f]|[A-F])){2}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}")))))
; throughpjpoptwql\u{2f}rlnjPOSTwebsearch\.getmirar\.comHost\x3Awww\x2EZSearchResults\x2EcomX-Mailer\x3A
(assert (str.in_re X (str.to_re "throughpjpoptwql/rlnjPOSTwebsearch.getmirar.comHost:www.ZSearchResults.com\u{13}X-Mailer:\u{13}\u{0a}")))
(check-sat)
