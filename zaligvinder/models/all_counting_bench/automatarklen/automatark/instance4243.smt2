(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\([0-9]{3}\)[0-9]{3}(-)[0-9]{4}
(assert (str.in_re X (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wsz/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wsz/i\u{0a}"))))
; \x0D\x0A\x0D\x0AAttached.*Host\x3A\s+ZC-Bridge
(assert (not (str.in_re X (re.++ (str.to_re "\u{0d}\u{0a}\u{0d}\u{0a}Attached") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ZC-Bridge\u{0a}")))))
; [\w!#$%&&apos;*+./=?`{|}~^-]+@[\d.A-Za-z-]+
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "!") (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "a") (str.to_re "p") (str.to_re "o") (str.to_re "s") (str.to_re ";") (str.to_re "*") (str.to_re "+") (str.to_re ".") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re "^") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (str.to_re ".") (re.range "A" "Z") (re.range "a" "z") (str.to_re "-"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
