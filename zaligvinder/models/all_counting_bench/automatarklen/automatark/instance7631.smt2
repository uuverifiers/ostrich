(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.gif\u{3f}[a-f0-9]{4,7}\u{3d}\d{6,8}$/U
(assert (str.in_re X (re.++ (str.to_re "/.gif?") ((_ re.loop 4 7) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; ^((\\\\[a-zA-Z0-9-]+\\[a-zA-Z0-9`~!@#$%^&(){}'._-]+([ ]+[a-zA-Z0-9`~!@#$%^&(){}'._-]+)*)|([a-zA-Z]:))(\\[^ \\/:*?""<>|]+([ ]+[^ \\/:*?""<>|]+)*)*\\?$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "\u{5c}\u{5c}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "\u{5c}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "{") (str.to_re "}") (str.to_re "'") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (re.* (re.++ (re.+ (str.to_re " ")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "{") (str.to_re "}") (str.to_re "'") (str.to_re ".") (str.to_re "_") (str.to_re "-")))))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":"))) (re.* (re.++ (str.to_re "\u{5c}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (re.* (re.++ (re.+ (str.to_re " ")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))))))) (re.opt (str.to_re "\u{5c}")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}rdp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rdp/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
