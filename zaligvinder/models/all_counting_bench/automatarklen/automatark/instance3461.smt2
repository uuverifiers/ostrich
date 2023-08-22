(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b([A-Za-z0-9]+)(-|_|\.)?(\w+)?@\w+\.(\w+)?(\.)?(\w+)?(\.)?(\w+)?\b
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re "_") (str.to_re "."))) (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.opt (str.to_re ".")) (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.opt (str.to_re ".")) (re.opt (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "\u{0a}"))))
; [-+]?((\.[0-9]+|[0-9]+\.[0-9]+)([eE][-+][0-9]+)?|[0-9]+)
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ (re.union (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9")))) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.union (str.to_re "-") (str.to_re "+")) (re.+ (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; \x2Frss\d+answer\sHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}")))))
; /^GET\u{20}\/plus\u{2e}asp\?[^\r\n]*?query=[a-z0-9+\/]{2,40}@{0,2}/i
(assert (str.in_re X (re.++ (str.to_re "/GET /plus.asp?") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "query=") ((_ re.loop 2 40) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) ((_ re.loop 0 2) (str.to_re "@")) (str.to_re "/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
