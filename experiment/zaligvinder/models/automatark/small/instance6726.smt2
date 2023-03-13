(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\.thecommunicator\.net[^\n\r]*iufilfwulmfi\u{2f}riuf\.lio
(assert (str.in_re X (re.++ (str.to_re "www.thecommunicator.net") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "iufilfwulmfi/riuf.lio\u{0a}"))))
; [A-Z|a-z]{4}[0][\d]{6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "0") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
