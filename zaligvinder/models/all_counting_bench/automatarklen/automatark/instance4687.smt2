(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z][a-z]+((i)?e(a)?(u)?[r(re)?|x]?)$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.opt (str.to_re "i")) (str.to_re "e") (re.opt (str.to_re "a")) (re.opt (str.to_re "u")) (re.opt (re.union (str.to_re "r") (str.to_re "(") (str.to_re "e") (str.to_re ")") (str.to_re "?") (str.to_re "|") (str.to_re "x")))))))
; IDENTIFY.*\x2Fezsb\d+X-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "IDENTIFY") (re.* re.allchar) (str.to_re "/ezsb") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}\u{0a}")))))
; \.cfg\x2Fsearchfast\x2F\u{22}007A-SpyWebsitehttp\x3A\x2F\x2Fsupremetoolbar\.com\x2Findex\.php\?tpid=
(assert (not (str.in_re X (str.to_re ".cfg/searchfast/\u{22}007A-SpyWebsitehttp://supremetoolbar.com/index.php?tpid=\u{0a}"))))
; /listoverridecount([2345678]|[019][0-9])/i
(assert (not (str.in_re X (re.++ (str.to_re "/listoverridecount") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1") (str.to_re "9")) (re.range "0" "9")) (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8")) (str.to_re "/i\u{0a}")))))
; ^(\d{1,4}?[.]{0,1}?\d{0,3}?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
