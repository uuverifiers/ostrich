(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; too[^\n\r]*User-Agent\x3A\sHost\x3A.*IP-WindowsAttachedPalas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (not (str.in_re X (re.++ (str.to_re "too") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "IP-WindowsAttachedPalas.starware.com/dp/search?x=\u{0a}")))))
; ^([0-9]{1})([0-9]{2})([0-9]{2})([0-9]{7})([0-9]{1})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[a-z]+([a-z0-9-]*[a-z0-9]+)?(\.([a-z]+([a-z0-9-]*[a-z0-9]+)?)+)*$
(assert (str.in_re X (re.++ (re.+ (re.range "a" "z")) (re.opt (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.++ (re.+ (re.range "a" "z")) (re.opt (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
