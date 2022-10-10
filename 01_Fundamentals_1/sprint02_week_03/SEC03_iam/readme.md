# [ Identity and access ]
Learning about authN and authZ. 

Study; The difference between authentication and authorization. The three factors of authentication and how MFA improves security. What the principle of least privilege is and how it improves security.


## Key terminology
- MFA: Multi-factor Authentication (MFA) is an authentication method that requires the user to provide two or more verification factors to gain access to a resource such as an application, online account, or a VPN.


## Exercise
### Sources
- https://www.onelogin.com/learn/authentication-vs-authorization#:~:text=Authentication%20and%20authorization%20are%20two,authorization%20determines%20their%20access%20rights.
- https://www.paloaltonetworks.com/cyberpedia/what-is-the-principle-of-least-privilege#:~:text=The%20principle%20of%20least%20privilege%20(PoLP)%20is%20an%20information%20security,to%20complete%20a%20required%20task.
- https://www.onelogin.com/learn/what-is-mfa
- https://www.globalknowledge.com/us-en/resources/resource-library/articles/the-three-types-of-multi-factor-authentication-mfa/#gref

### Overcome challenges
Didn't knew the exact details of what authentication and authorization was so I needed to do research.

### Results

Authentication and authorization often go hand in hand and are both vital information security processes to protect systems and information. They sound alike put play different roles in security. 

So what is Authentication?
Authentication (AuthN) verifies the identity of a user, when you need acces to an online site or service you often have to enter a username and password. That way the system can see if your information matches the one in their database it can grand you acces to their services. They point of authentication is to verify that someone/something is who they claim to be.

Some common types of Authentication are:
- Passwords and usernames
- A physical device; such as USB tokens and mobile phones via an SMS or an app.
- Biometric authentication; things that are physically unique such as fingerprints.

What is Authorization?
Authorizations (AuthZ) is a security process that determines a user or service's level of access. AuthZ is used to give users or services permission to access certain data or preform a perticular action. The system uses AuthN to verify the user's identity and provide them with their respective permissions.

Some common types of Authorization are:
- Access Control Lists (ACLs); determines which users or services can access a particular digital environment. They accomplish this access control by enforcing allow or deny rules based on the user's authorization level.
- Acces to data; In any enterprise environment, you typically have data with different levels of sensitivity. For example, you may have public data that you find on the company's website, internal data that is only accessible to employees, and confidential data that only a handful of individuals can access. 

![](./../../../00_includes)

The three factors of authentication are:
- Something you know (such as a password) 
- Something you have (such as a key) 
- Something you are (such as a fingerprint)

The principle of least privilege (PoLP) is an information security concept which maintains that a user or entity should only have access to the specific data, resources and applications needed to complete a required task. Organizations that follow the principle of least privilege can improve their security posture by significantly reducing their attack surface and risk of malware spread.