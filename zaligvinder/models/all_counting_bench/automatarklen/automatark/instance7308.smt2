(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; AD\s+c\.goclick\.com\w+asdbiz\x2Ebizfrom\u{7c}roogoo\u{7c}Current
(assert (not (str.in_re X (re.++ (str.to_re "AD") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "c.goclick.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "asdbiz.bizfrom|roogoo|Current\u{0a}")))))
; ^[a-zA-Z]\:\\.*|^\\\\.*
(assert (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":\u{5c}") (re.* re.allchar)) (re.++ (str.to_re "\u{5c}\u{5c}") (re.* re.allchar) (str.to_re "\u{0a}")))))
; (^\d{1,5}$|^\d{1,5}\.\d{1,2}$)
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; dialupvpn\u{5f}pwd\d\<title\>Actual\sSpywareStrike\s+fowclxccdxn\u{2f}uxwn\.ddywww\u{2e}virusprotectpro\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "dialupvpn_pwd") (re.range "0" "9") (str.to_re "<title>Actual") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "SpywareStrike") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "fowclxccdxn/uxwn.ddywww.virusprotectpro.com\u{0a}"))))
; (^\d{1,3}([,]\d{3})*$)|(^\d{1,16}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 16) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
