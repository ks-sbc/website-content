// Review Date Manager
async function manageReviewDates(tp) {
    const lastReview = tp.frontmatter.last_review;
    const reviewInterval = tp.frontmatter.review_interval || '180'; // Default 6 months
    
    const nextReview = new Date();
    nextReview.setDate(nextReview.getDate() + parseInt(reviewInterval));
    
    return {
      last_review: tp.date.now("YYYY-MM-DD"),
      next_review: tp.date.now("YYYY-MM-DD", nextReview)
    };
}

module.exports = manageReviewDates;
