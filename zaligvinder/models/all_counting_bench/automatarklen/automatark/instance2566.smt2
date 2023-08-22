(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\sToolbarServerserver\x7D\x7BSysuptime\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "ToolbarServerserver}{Sysuptime:\u{0a}"))))
; ^([1][0-9]|[0-9])[1-9]{2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "9")) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
