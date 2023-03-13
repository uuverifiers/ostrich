(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1,2}((,)|(,25)|(,50)|(,5)|(,75)|(,0)|(,00))?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re ",25") (str.to_re ",50") (str.to_re ",5") (str.to_re ",75") (str.to_re ",0") (str.to_re ",00"))) (str.to_re "\u{0a}")))))
; YOUR.*\x2Fsearchfast\x2F\s+hostiedesksearch\.dropspam\.com\x2Fbi\x2Fservlet\x2FThinstall
(assert (str.in_re X (re.++ (str.to_re "YOUR") (re.* re.allchar) (str.to_re "/searchfast/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostiedesksearch.dropspam.com/bi/servlet/Thinstall\u{0a}"))))
; nick_name=CIA-Test\s+User-Agent\x3A\s+Downloadfowclxccdxn\u{2f}uxwn\.ddywww\x2Eeasymessage\x2Enet
(assert (not (str.in_re X (re.++ (str.to_re "nick_name=CIA-Test") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Downloadfowclxccdxn/uxwn.ddywww.easymessage.net\u{0a}")))))
(check-sat)
