(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}SpywareSpyBuddy
(assert (not (str.in_re X (str.to_re "Subject:SpywareSpyBuddy\u{0a}"))))
; (^\d{1,2}\.\d{1,2}\.\d{4})|(^\d{1,2}\.\d{1,2})|(^\d{1,2})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^[0-9]+[NnSs] [0-9]+[WwEe]$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.union (str.to_re "N") (str.to_re "n") (str.to_re "S") (str.to_re "s")) (str.to_re " ") (re.+ (re.range "0" "9")) (re.union (str.to_re "W") (str.to_re "w") (str.to_re "E") (str.to_re "e")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
