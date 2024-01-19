(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\.([rR]([aA][rR]|\d{2})|(\d{3})?)$
(assert (str.in_re X (re.++ (str.to_re ".") (re.union (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "r") (str.to_re "R"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ToolbarUser-Agent\x3Awww\x2Ewebcruiser\x2EccDaemonUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "ToolbarUser-Agent:www.webcruiser.ccDaemonUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
