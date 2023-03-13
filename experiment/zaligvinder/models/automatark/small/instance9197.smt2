(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; www\x2Eserverlogic3\x2Ecom\d+ToolBar\s+HWAEUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "www.serverlogic3.com") (re.+ (re.range "0" "9")) (str.to_re "ToolBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAEUser-Agent:\u{0a}"))))
; ^[a-zA-z0-9]+[@]{1}[a-zA-Z]+[.]{1}[a-zA-Z]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; ^[A-Z]{2,4}[0-9][A-Z0-9]+$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "A" "Z")) (re.range "0" "9") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; media\x2Etop-banners\x2Ecom
(assert (str.in_re X (str.to_re "media.top-banners.com\u{0a}")))
(check-sat)
