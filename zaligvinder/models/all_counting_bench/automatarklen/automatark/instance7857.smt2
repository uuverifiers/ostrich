(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}swf([\u{3f}\u{2f}]|$)/Uim
(assert (str.in_re X (re.++ (str.to_re "/.swf") (re.union (str.to_re "?") (str.to_re "/")) (str.to_re "/Uim\u{0a}"))))
; Host\x3A.*NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\n
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}\u{0a}"))))
; ^[^iIoOqQ'-]{10,17}$
(assert (not (str.in_re X (re.++ ((_ re.loop 10 17) (re.union (str.to_re "i") (str.to_re "I") (str.to_re "o") (str.to_re "O") (str.to_re "q") (str.to_re "Q") (str.to_re "'") (str.to_re "-"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
