(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(USER|NICK)\u{20}BOSS\u{2d}[A-Z0-9\u{5b}\u{5d}\u{2d}]{15}/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "USER") (str.to_re "NICK")) (str.to_re " BOSS-") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "[") (str.to_re "]") (str.to_re "-"))) (str.to_re "/\u{0a}")))))
; source\=IncrediFind\s+Host\x3A\s+Host\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "source=IncrediFind") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{0a}")))))
; User-Agent\x3AMailerGuarded
(assert (str.in_re X (str.to_re "User-Agent:MailerGuarded\u{0a}")))
(check-sat)
