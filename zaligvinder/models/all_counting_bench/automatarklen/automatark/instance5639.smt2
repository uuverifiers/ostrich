(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^100$|^100.00$|^\d{0,2}(\.\d{1,2})? *%?$
(assert (not (str.in_re X (re.union (str.to_re "100") (re.++ (str.to_re "100") re.allchar (str.to_re "00")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))))
; Host\x3A.*NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\n
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
