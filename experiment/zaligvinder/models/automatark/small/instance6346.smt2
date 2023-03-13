(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+Boss\s+media\x2Etop-banners\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Boss") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.top-banners.com\u{0a}"))))
; /\/14\d{8}(.jar)?$/U
(assert (str.in_re X (re.++ (str.to_re "//14") ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.++ re.allchar (str.to_re "jar"))) (str.to_re "/U\u{0a}"))))
; (/\*[\d\D]*?\*/)|(\/\*(\s*|.*?)*\*\/)|(\/\/.*)|(/\\*[\\d\\D]*?\\*/)|([\r\n ]*//[^\r\n]*)+
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/*") (re.* (re.union (re.range "0" "9") (re.comp (re.range "0" "9")))) (str.to_re "*/")) (re.++ (str.to_re "/*") (re.* (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar))) (str.to_re "*/")) (re.++ (str.to_re "//") (re.* re.allchar)) (re.++ (str.to_re "/") (re.* (str.to_re "\u{5c}")) (re.* (re.union (str.to_re "\u{5c}") (str.to_re "d") (str.to_re "D"))) (re.* (str.to_re "\u{5c}")) (str.to_re "/")) (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " "))) (str.to_re "//") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) (str.to_re "\u{0a}"))))))
; ^.{2,}$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) re.allchar) (re.* re.allchar))))
(check-sat)
