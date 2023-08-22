(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}searchresltwww\x2Ewordiq\x2Ecomwww2\u{2e}instantbuzz\u{2e}com
(assert (not (str.in_re X (str.to_re "Host:searchresltwww.wordiq.com\u{1b}www2.instantbuzz.com\u{0a}"))))
; [AaEeIiOoUuYy]
(assert (str.in_re X (re.++ (re.union (str.to_re "A") (str.to_re "a") (str.to_re "E") (str.to_re "e") (str.to_re "I") (str.to_re "i") (str.to_re "O") (str.to_re "o") (str.to_re "U") (str.to_re "u") (str.to_re "Y") (str.to_re "y")) (str.to_re "\u{0a}"))))
; &lt;/?([a-zA-Z][-A-Za-z\d\.]{0,71})(\s+(\S+)(\s*=\s*([-\w\.]{1,1024}|&quot;[^&quot;]{0,1024}&quot;|'[^']{0,1024}'))?)*\s*&gt;
(assert (str.in_re X (re.++ (str.to_re "&lt;") (re.opt (str.to_re "/")) (re.* (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 1 1024) (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.++ (str.to_re "&quot;") ((_ re.loop 0 1024) (re.union (str.to_re "&") (str.to_re "q") (str.to_re "u") (str.to_re "o") (str.to_re "t") (str.to_re ";"))) (str.to_re "&quot;")) (re.++ (str.to_re "'") ((_ re.loop 0 1024) (re.comp (str.to_re "'"))) (str.to_re "'"))))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "&gt;\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 71) (re.union (str.to_re "-") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "."))))))
(assert (< 200 (str.len X)))
(check-sat)
