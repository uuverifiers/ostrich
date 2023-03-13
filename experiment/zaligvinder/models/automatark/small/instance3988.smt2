(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; linkautomatici\x2Ecom\dBasic\d+Host\x3AFloodedFictionalUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "linkautomatici.com") (re.range "0" "9") (str.to_re "Basic") (re.+ (re.range "0" "9")) (str.to_re "Host:FloodedFictionalUser-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}spx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".spx/i\u{0a}"))))
; /filename=[^\n]*\u{2e}fli/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fli/i\u{0a}"))))
; Subject\x3A\s+Host\x3A.*www\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "www.alfacleaner.com\u{0a}"))))
; ^(X(-|\.)?0?\d{7}(-|\.)?[A-Z]|[A-Z](-|\.)?\d{7}(-|\.)?[0-9A-Z]|\d{8}(-|\.)?[A-Z])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "X") (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.opt (str.to_re "0")) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(check-sat)
