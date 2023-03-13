(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [^(\&)](\w*)+(\=)[\w\d ]*
(assert (not (str.in_re X (re.++ (re.union (str.to_re "(") (str.to_re "&") (str.to_re ")")) (re.+ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "=") (re.* (re.union (re.range "0" "9") (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /\/download\.asp\?p\=\d$/Ui
(assert (str.in_re X (re.++ (str.to_re "//download.asp?p=") (re.range "0" "9") (str.to_re "/Ui\u{0a}"))))
; libManager\x2Edll\x5Eget
(assert (str.in_re X (str.to_re "libManager.dll^get\u{0a}")))
; (private|public|protected)\s\w(.)*\((.)*\)[^;]
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* re.allchar) (str.to_re "(") (re.* re.allchar) (str.to_re ")") (re.comp (str.to_re ";")) (str.to_re "\u{0a}p") (re.union (str.to_re "rivate") (str.to_re "ublic") (str.to_re "rotected")))))
; \([+]?[ ]?\d{1,3}[)][ ]?[(][+]?[ ]?\d{1,3}[)][- ]?\d{4}[- ]?\d{4}
(assert (not (str.in_re X (re.++ (str.to_re "(") (re.opt (str.to_re "+")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " ")) (str.to_re "(") (re.opt (str.to_re "+")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
