(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sidesearch\.dropspam\.com\s+Strip-Player\s+
(assert (not (str.in_re X (re.++ (str.to_re "sidesearch.dropspam.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Strip-Player\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^(\S+\.{1})(\S+\.{1})*([^\s\.]+\s*)$
(assert (not (str.in_re X (re.++ (re.* (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 1 1) (str.to_re ".")))) (str.to_re "\u{0a}") (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; The company delivers cakes and also online send mothers  day flowers to Delhi.
(assert (not (str.in_re X (re.++ (str.to_re "The company delivers cakes and also online send mothers  day flowers to Delhi") re.allchar (str.to_re "\u{0a}")))))
; ((19|20)[\d]{2}/[\d]{6}/[\d]{2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "19") (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")))))
(check-sat)
