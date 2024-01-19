(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^udp\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/udp|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; ^[0-9]+[NnSs] [0-9]+[WwEe]$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.union (str.to_re "N") (str.to_re "n") (str.to_re "S") (str.to_re "s")) (str.to_re " ") (re.+ (re.range "0" "9")) (re.union (str.to_re "W") (str.to_re "w") (str.to_re "E") (str.to_re "e")) (str.to_re "\u{0a}"))))
; User-Agent\x3A\s+Robert
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Robert\u{0a}")))))
; /\u{2e}setTimeOut\s*\u{28}\s*[\u{22}\u{27}][^\u{28}]+?\u{2e}closeDoc\s*\u{28}[^\u{29}]*?\u{29}[^\u{28}]+?\u{2e}openDoc\s*\u{28}[^\u{29}]*?\u{29}[^\u{29}]*?[\u{22}\u{27}]\s*,\s*[^\u{29}]*?\u{29}/i
(assert (not (str.in_re X (re.++ (str.to_re "/.setTimeOut") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.+ (re.comp (str.to_re "("))) (str.to_re ".closeDoc") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")") (re.+ (re.comp (str.to_re "("))) (str.to_re ".openDoc") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.* (re.comp (str.to_re ")"))) (str.to_re ")") (re.* (re.comp (str.to_re ")"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re ")"))) (str.to_re ")/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
