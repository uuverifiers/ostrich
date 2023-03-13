(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+Boss\s+media\x2Etop-banners\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Boss") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.top-banners.com\u{0a}")))))
; &[a-zA-Z]+\d{0,3};
(assert (str.in_re X (re.++ (str.to_re "&") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re ";\u{0a}"))))
; .*[a-zA-Z]$
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; /^(\u{75}|\u{2d}|\u{2f}|\u{73}|\u{a2}|\u{2e}|\u{24}|\u{74})/sR
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "u") (str.to_re "-") (str.to_re "/") (str.to_re "s") (str.to_re "\u{a2}") (str.to_re ".") (str.to_re "$") (str.to_re "t")) (str.to_re "/sR\u{0a}"))))
; ([0-9a-z_-]+[\.][0-9a-z_-]{1,3})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "a" "z") (str.to_re "_") (str.to_re "-"))))))
(check-sat)
