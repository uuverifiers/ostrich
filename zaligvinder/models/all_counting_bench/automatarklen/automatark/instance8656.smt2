(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((([sS][r-tR-Tx-zX-Z])\s*([sx-zSX-Z])?\s*([a-zA-Z]{2,3}))?\s*(\d\d)\s*-?\s*(\d{6,7}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "s") (re.range "x" "z") (str.to_re "S") (re.range "X" "Z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re "s") (str.to_re "S")) (re.union (re.range "r" "t") (re.range "R" "T") (re.range "x" "z") (re.range "X" "Z")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 7) (re.range "0" "9")) (re.range "0" "9") (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}quo/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".quo/i\u{0a}"))))
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; configINTERNAL\.ini.*SecureNet\s+User-Agent\x3Aregister\.asp
(assert (str.in_re X (re.++ (str.to_re "configINTERNAL.ini") (re.* re.allchar) (str.to_re "SecureNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:register.asp\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
