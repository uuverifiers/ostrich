(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^connected\u{2e}[^\x0D\x0A]*20\d\d[^\x0D\x0A]*ver\x3A\s+Legends\s2\u{2e}1/smi
(assert (str.in_re X (re.++ (str.to_re "/connected.") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "20") (re.range "0" "9") (re.range "0" "9") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "ver:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Legends") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "2.1/smi\u{0a}"))))
; ^\{[A-Fa-f\d]{8}-[A-Fa-f\d]{4}-[A-Fa-f0\d]{4}-[A-Fa-f\d]{4}-[A-Fa-f\d]{12}\}$
(assert (not (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (str.to_re "0") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "a" "f") (re.range "0" "9"))) (str.to_re "}\u{0a}")))))
; Host\x3AFrom\u{3a}User-Agent\x3A\x2Fr\x2Fkeys\x2FkeysClient
(assert (str.in_re X (str.to_re "Host:From:User-Agent:/r/keys/keysClient\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
