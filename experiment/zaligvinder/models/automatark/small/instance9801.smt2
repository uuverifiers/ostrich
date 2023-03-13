(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}rtf([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rtf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /[^/]+$
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "/"))) (str.to_re "\u{0a}"))))
; ^(\([2-9]|[2-9])(\d{2}|\d{2}\))(-|.|\s)?\d{3}(-|.|\s)?\d{4}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.range "2" "9")) (re.range "2" "9")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")"))) (re.opt (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\u{3a}\s+Host\x3A\s+proxystylesheet=Excitefhfksjzsfu\u{2f}ahm\.uqs
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "proxystylesheet=Excitefhfksjzsfu/ahm.uqs\u{0a}"))))
(check-sat)
