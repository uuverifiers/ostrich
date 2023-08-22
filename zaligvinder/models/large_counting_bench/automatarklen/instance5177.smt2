(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\(?\+?[0-9]*\)?)?[0-9_\- \(\)]*$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (re.opt (str.to_re "+")) (re.* (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.* (re.union (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re " ") (str.to_re "(") (str.to_re ")"))) (str.to_re "\u{0a}")))))
; Pattern that matches all DVLA Vehicle Registration Marks (VRM). Allows for an optional single space between segments.
(assert (not (str.in_re X (re.++ (str.to_re "Pattern that matches all DVLA Vehicle Registration Marks VRM") re.allchar (str.to_re " Allows for an optional single space between segments") re.allchar (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}flac/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}")))))
; [\w]+\@[\w]+\.?[\w]+?\.?[\w]+?\.?[\w+]{2,4}
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) ((_ re.loop 2 4) (re.union (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /^\/images2\/[0-9a-fA-F]{500,}/U
(assert (not (str.in_re X (re.++ (str.to_re "//images2//U\u{0a}") ((_ re.loop 500 500) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))))))
(assert (< 200 (str.len X)))
(check-sat)
