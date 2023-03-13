(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; onBetaHost\u{3a}youRootReferer\x3A
(assert (str.in_re X (str.to_re "onBetaHost:youRootReferer:\u{0a}")))
; ^[+-]?\d+(\,\d{3})*\.?\d*\%?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}"))))
; XP\d+Acme\s+\x2Fcbn\x2Fnode=Host\x3A\x3Fsearch\x3DversionContact
(assert (not (str.in_re X (re.++ (str.to_re "XP") (re.+ (re.range "0" "9")) (str.to_re "Acme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cbn/node=Host:?search=versionContact\u{0a}")))))
; &lt;/?([a-zA-Z][-A-Za-z\d\.]{0,71})(\s+(\S+)(\s*=\s*([-\w\.]{1,1024}|&quot;[^&quot;]{0,1024}&quot;|'[^']{0,1024}'))?)*\s*&gt;
(assert (not (str.in_re X (re.++ (str.to_re "&lt;") (re.opt (str.to_re "/")) (re.* (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 1 1024) (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.++ (str.to_re "&quot;") ((_ re.loop 0 1024) (re.union (str.to_re "&") (str.to_re "q") (str.to_re "u") (str.to_re "o") (str.to_re "t") (str.to_re ";"))) (str.to_re "&quot;")) (re.++ (str.to_re "'") ((_ re.loop 0 1024) (re.comp (str.to_re "'"))) (str.to_re "'"))))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "&gt;\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 0 71) (re.union (str.to_re "-") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re ".")))))))
(check-sat)
