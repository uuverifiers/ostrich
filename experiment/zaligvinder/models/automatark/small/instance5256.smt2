(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \bfor\b.*[A-Za-z][<> ][\d]
(assert (str.in_re X (re.++ (str.to_re "for") (re.* re.allchar) (re.union (re.range "A" "Z") (re.range "a" "z")) (re.union (str.to_re "<") (str.to_re ">") (str.to_re " ")) (re.range "0" "9") (str.to_re "\u{0a}"))))
; ([A-Za-z]{2}|[A-Za-z]\d|\d[A-Za-z])[A-Za-z]{0,1}\d(\d{0,3})[A-Za-z]{0,1}
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")) (re.++ (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.range "0" "9") ((_ re.loop 0 3) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; Version\s+User-Agent\x3Abindmqnqgijmng\u{2f}oj
(assert (not (str.in_re X (re.++ (str.to_re "Version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:bindmqnqgijmng/oj\u{0a}")))))
; <\s*?[^>]+\s*?>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.comp (str.to_re ">"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">\u{0a}")))))
(check-sat)
