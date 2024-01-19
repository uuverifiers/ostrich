(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}motn([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.motn") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (^\d{3,4}\-\d{4}$)|(^\d{7,8}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ((v|[\\/])\W*[i1]\W*[a@]\W*g\W*r\W*[a@]|v\W*[i1]\W*[c]\W*[o0]\W*d\W*[i1]\W*n)
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "v") (str.to_re "\u{5c}") (str.to_re "/")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "i") (str.to_re "1")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "a") (str.to_re "@")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "g") (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "r") (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "a") (str.to_re "@"))) (re.++ (str.to_re "v") (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "i") (str.to_re "1")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "c") (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "o") (str.to_re "0")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "d") (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "i") (str.to_re "1")) (re.* (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (str.to_re "n"))) (str.to_re "\u{0a}")))))
; [^<>/?&{};#]+
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "<") (str.to_re ">") (str.to_re "/") (str.to_re "?") (str.to_re "&") (str.to_re "{") (str.to_re "}") (str.to_re ";") (str.to_re "#"))) (str.to_re "\u{0a}")))))
; ^(NAME)(\s?)<?(\w*)(\s*)([0-9]*)>?$
(assert (not (str.in_re X (re.++ (str.to_re "NAME") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "<")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.range "0" "9")) (re.opt (str.to_re ">")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
