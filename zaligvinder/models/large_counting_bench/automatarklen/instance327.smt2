(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; com\x2Findex\.php\?tpid=\x7D\x7BUser\x3A
(assert (not (str.in_re X (str.to_re "com/index.php?tpid=}{User:\u{0a}"))))
; ^((0[1-9])|(1[0-2]))\/(\d{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\/[-\w]{70,78}==?$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 70 78) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.opt (str.to_re "=")) (str.to_re "/U\u{0a}"))))
; www\u{2e}2-seek\u{2e}com\u{2f}searchUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "www.2-seek.com/searchUser-Agent:\u{0a}"))))
; ^\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
