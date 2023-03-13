(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; seqepagqfphv\u{2f}sfdX-Mailer\x3A
(assert (str.in_re X (str.to_re "seqepagqfphv/sfdX-Mailer:\u{13}\u{0a}")))
; ^(000-)(\\d{5}-){2}\\d{3}$
(assert (str.in_re X (re.++ (str.to_re "000-") ((_ re.loop 2 2) (re.++ (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d")) (str.to_re "-"))) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\u{0a}"))))
; ^(.*)
(assert (str.in_re X (re.++ (re.* re.allchar) (str.to_re "\u{0a}"))))
; SecureNet\s+hostiedesksearch\.dropspam\.com
(assert (not (str.in_re X (re.++ (str.to_re "SecureNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostiedesksearch.dropspam.com\u{0a}")))))
; /filename=[^\n]*\u{2e}f4p/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4p/i\u{0a}"))))
(check-sat)
