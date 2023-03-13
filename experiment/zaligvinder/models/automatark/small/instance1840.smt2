(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d+\.ld$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re ".ld/U\u{0a}")))))
; devSoft\u{27}s\s+Host\x3A\s+Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "devSoft's\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}")))))
; ^[^ \\/:*?""<>|]+([ ]+[^ \\/:*?""<>|]+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (re.* (re.++ (re.+ (str.to_re " ")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}afm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".afm/i\u{0a}")))))
; (:[a-z]{1}[a-z1-9\$#_]*){1,31}
(assert (str.in_re X (re.++ ((_ re.loop 1 31) (re.++ (str.to_re ":") ((_ re.loop 1 1) (re.range "a" "z")) (re.* (re.union (re.range "a" "z") (re.range "1" "9") (str.to_re "$") (str.to_re "#") (str.to_re "_"))))) (str.to_re "\u{0a}"))))
(check-sat)
