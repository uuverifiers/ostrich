(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^http[s]?://twitter\.com/(#!/)?[a-zA-Z0-9]{1,15}[/]?$
(assert (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://twitter.com/") (re.opt (str.to_re "#!/")) ((_ re.loop 1 15) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}"))))
; /^[0-9]+\.d{3}? *$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (str.to_re "d")) (re.* (str.to_re " ")) (str.to_re "/\u{0a}")))))
; /^\s*?RCPT\s+?TO\u{3a}[^\r\n]*?\u{28}\u{29}\s\u{7b}/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "RCPT") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TO:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "()") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "{/i\u{0a}")))))
; /^\d{0,10}_passes_\d{1,10}\.xm/iR
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "_passes_") ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re ".xm/iR\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
