(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+65)?\d{8}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+65")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}xbm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xbm/i\u{0a}"))))
; hostie\s+freeIPaddrs\s+TPSystemHost\u{3a}\x7D\x7BUser\x3AAlert\x2Fcgi-bin\x2F
(assert (str.in_re X (re.++ (str.to_re "hostie") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "freeIPaddrs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TPSystemHost:}{User:Alert/cgi-bin/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
