(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/MacApp\/\d{2}(-\d{2}){3}(:\d{2}){2}\.png\r\n[^\u{89}]+?\u{89}PNG/Psmi
(assert (str.in_re X (re.++ (str.to_re "//MacApp/") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 2 2) (re.++ (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re ".png\u{0d}\u{0a}") (re.+ (re.comp (str.to_re "\u{89}"))) (str.to_re "\u{89}PNG/Psmi\u{0a}"))))
; ^([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1} --> ([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1}(.*)$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re " --> ") ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.* re.allchar) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}jpm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpm/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
