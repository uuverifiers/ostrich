(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}xsl([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xsl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^N[1-9][0-9]{0,4}$|^N[1-9][0-9]{0,3}[A-Z]$|^N[1-9][0-9]{0,2}[A-Z]{2}$
(assert (str.in_re X (re.++ (str.to_re "N") (re.range "1" "9") (re.union ((_ re.loop 0 4) (re.range "0" "9")) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.range "A" "Z")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))))
; User-Agent\x3A\d+Desktop\sIDENTIFY666User-Agent\x3A\x5BStatic
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Desktop") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "IDENTIFY666User-Agent:[Static\u{0a}")))))
; FreeAccessBar\s+hostie[^\n\r]*CodeguruBrowser\dStableWeb-MailUser-Agent\x3A195\.225\.Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "FreeAccessBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostie") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowser") (re.range "0" "9") (str.to_re "StableWeb-MailUser-Agent:195.225.Subject:\u{0a}")))))
(check-sat)
