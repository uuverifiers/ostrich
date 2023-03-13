(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?\d+([.,]\d{0,2}){0,1}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (a|b|c).(a.b)*.b+.c
(assert (str.in_re X (re.++ (re.union (str.to_re "a") (str.to_re "b") (str.to_re "c")) re.allchar (re.* (re.++ (str.to_re "a") re.allchar (str.to_re "b"))) re.allchar (re.+ (str.to_re "b")) re.allchar (str.to_re "c\u{0a}"))))
; dialupvpn\u{5f}pwd\d\<title\>Actual\sSpywareStrike\s+fowclxccdxn\u{2f}uxwn\.ddywww\u{2e}virusprotectpro\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "dialupvpn_pwd") (re.range "0" "9") (str.to_re "<title>Actual") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "SpywareStrike") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "fowclxccdxn/uxwn.ddywww.virusprotectpro.com\u{0a}")))))
; DaysLOGHost\u{3a}Host\u{3a}\x7D\x7BOS\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "DaysLOGHost:Host:}{OS:Host:\u{0a}"))))
(check-sat)
