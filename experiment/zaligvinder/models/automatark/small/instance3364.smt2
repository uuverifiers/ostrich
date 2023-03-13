(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbar\d+ServerLiteToolbardailywww\x2Ecameup\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "ServerLiteToolbardailywww.cameup.com\u{13}\u{0a}"))))
; ^[1-9][0-9]{1,6}\-[0-9]{2}\-[0-9]
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 1 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; AD\s+c\.goclick\.com\w+asdbiz\x2Ebizfrom\u{7c}roogoo\u{7c}Current
(assert (str.in_re X (re.++ (str.to_re "AD") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "c.goclick.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "asdbiz.bizfrom|roogoo|Current\u{0a}"))))
(check-sat)
