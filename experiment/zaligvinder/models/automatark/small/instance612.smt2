(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[5,6]\d{7}|^$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "5") (str.to_re ",") (str.to_re "6")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^(\d{1}\.){0,1}\d{1,3}\,\d{2}$
(assert (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; c\.goclick\.com\s+URLBlaze\s+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "c.goclick.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; 12/err
(assert (str.in_re X (str.to_re "12/err\u{0a}")))
; <!\[CDATA\[([^\]]*)\]\]>
(assert (not (str.in_re X (re.++ (str.to_re "<![CDATA[") (re.* (re.comp (str.to_re "]"))) (str.to_re "]]>\u{0a}")))))
(check-sat)
