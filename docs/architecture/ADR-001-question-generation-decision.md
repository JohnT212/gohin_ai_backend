Decision for the first feature: Question Generation 

After consideration, I will narrow down the scope of question generation features.
1. focus on multiple choice only (may extend to the long question, esssay in the future)
2. focus on the STEM subject first, mainly Physics, Chemistry, Mathmatics (extand to english, chinese, history later on)
3. And for the question generation, better to refer to hong kong syllbus if possible
4. for early phase, our focus function should be similar question generation, which is generate the question based on the provided example. but later on, it can try to use RAG/DB query, to read the similar questions from different source, and come up the question generation based on the user topic selection. 
5. and picture generation is too challenging, and hard to control. so I will only carry out experiment in very late stage. but the picture input may be accepted in the second phase.


For better customization ability and user friendly, user can choose to input:
1. difficulty variance (easier, similar, harder, and killer level) (default similar): the original difficulty level will be range 1-5, the user can choose to generate a question a little bit harder, or easier. 
2. no variance flag (default off): if this flag is on, which means, user just want to generate a question with exact same knowledge point, and in slighly different phrase, if it is numerical question, it will be just replace with a new set of numbers. 


1. What makes two questions "similar"?
   - Same difficulty level? ==> not necessary, it can have different difficulty level, depends on the input 
   - Same topic coverage?  ==> yes, they should be same topic, so anlysis it first  
   - Same question type (multiple choice, essay)?  ==> yes, it should be same question type 

2. What are the constraints?
   - Must maintain same subject? ==> yes, it must be same subject, like physics 
   - Must have same number of options? ==> yes, limit the options to 4 ()
   - Must test same knowledge points? ==> yes, same knowledge points with different varaints of question asking, if the user input with variants, then it should be similiar topic with 

3. What defines "quality"?  ==> the question and the choice is valid. and is the difficulty level match with the user input. 

4. What are failure scenarios?
   - OpenAI returns inappropriate content  ==> retry
   - Generated question is identical to input  ==> modify prompting
   - API rate limits exceeded ==> send out the response to the backend
   - Network failures ==> retry


## Status: Accepted
## Date: 2025-07-12