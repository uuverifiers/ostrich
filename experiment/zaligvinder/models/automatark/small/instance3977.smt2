(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[http|ftp|wap|https]{3,5}:\//\www\.\w*\.[com|net]{2,3}$
(assert (str.in_re X (re.++ ((_ re.loop 3 5) (re.union (str.to_re "h") (str.to_re "t") (str.to_re "p") (str.to_re "|") (str.to_re "f") (str.to_re "w") (str.to_re "a") (str.to_re "s"))) (str.to_re "://") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re "ww.") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "c") (str.to_re "o") (str.to_re "m") (str.to_re "|") (str.to_re "n") (str.to_re "e") (str.to_re "t"))) (str.to_re "\u{0a}"))))
; \(([0-9]{2}|0{1}((x|[0-9]){2}[0-9]{2}))\)\s*[0-9]{3,4}[- ]*[0-9]{4}
(assert (not (str.in_re X (re.++ (str.to_re "(") (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 2 2) (re.union (str.to_re "x") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re ")") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 4) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((Fred|Wilma)\s+Flintstone|(Barney|Betty)\s+Rubble)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "Fred") (str.to_re "Wilma")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Flintstone")) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "RubbleB") (re.union (str.to_re "arney") (str.to_re "etty")))) (str.to_re "\u{0a}")))))
; Version\s+User-Agent\x3Abindmqnqgijmng\u{2f}oj
(assert (str.in_re X (re.++ (str.to_re "Version") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:bindmqnqgijmng/oj\u{0a}"))))
(check-sat)
